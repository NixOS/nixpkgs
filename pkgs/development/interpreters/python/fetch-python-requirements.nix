# fetchPythonRequirements downlaods python packages specified by a list of
# pip-style python requirements
# It also requires a maximum date 'maxDate' being specified.
# The result will be as if `pip download` would have been executed
# at the point in time specified by maxDate.
# This is ensured by putting pip behind a local proxy filtering the
# api responses from pypi.org to only contain files for which the
# release date is lower than the specified maxDate.

{
  # This specifies the python version for which the packages should be downloaded
  # Pip needs to be executed from that specific python version.
  # Pip accepts '--python-version', but this works only for wheel packages.
  python

  # Changing this version might affect the result of the fetcher.
  # Make sure to re-compute all depending FOD hashes
, logicVersion

, buildPackages
, cacert
, curl
, lib
, pythonMitmproxy
, stdenv
}:
let

  # Whenever this fetcher is modified in a way that might change its result,
  # the change should be hidden behind this logic switch and only enabled,
  # if `logicVersion = {new_num}` is passed
  currentLogic = {
    "1" = {};  # reserved for version 1

    # Example for next version
    # "2" = {
    #   pipFlags = "--some --new --flags --for --pip";
    # };

  }."${logicVersion}";

  interpreterVersion = lib.concatStringsSep "." (lib.sublist 0 2 (lib.splitString "." python.version));

  # we use mitmproxy to filter the pypi responses
  pythonWithMitmproxy = pythonMitmproxy.withPackages (ps: [ ps.mitmproxy ps.python-dateutil ]);

  fetchPythonRequirements = {
    maxDate,        # maximum release date for packages
    outputHash,     # hash for the fixed output derivation
    requirements,   # list of strings of specs

    # restrict to binary releases (.whl)
    # this allows buildPlatform independent fetching
    onlyBinary ? false,

    # additional flags for `pip download`.
    # for reference see: https://pip.pypa.io/en/stable/cli/pip_download/
    pipFlags ? [],


    # The following inputs must be static
    # If unset, an erorr is thrown with usage instructions.

    pipVersion ? throw ''
      'pipVersion' must be specified for fetchPythonRequirements.
      This value must be static and not depend on other variables.
      This prevents the fetcher from being executed with the wrong pip version.
      If you change this value, make sure to re-compute the outputHash.
      Example value: "21.1.1"
    '',

    pythonVersion ? throw ''
      'pythonVersion' must be specified for fetchPythonRequirements.
      This value must be static and not depend on other variables.
      This prevents the fetcher from being executed with the wrong python version.
      If you change this value, make sure to re-compute the outputHash.
      Example value: "3.9"
    '',

    targetSystem ? throw ''
      'targetSystem' must be specified for fetchPythonRequirements.
      This value must be static and not depend on other variables.
      This prevents the fetcher from being executed on the wrong platform.
      If you change this value, make sure to re-compute the outputHash.
      Example value: 'x86_64-linux'
    '',
  }:

    # specifying `--platform` for pip download is only allowed in combination with `--only-binary :all:`
    # therefore, if onlyBinary is disabled, we must enforce targetPlatform == buildPlatform to ensure reproducibility
    if ! onlyBinary && targetSystem != stdenv.buildPlatform.system then
      throw ''
        fetchPythonRequirements cannot fetch sdist packages for ${targetSystem} on a ${stdenv.buildPlatform.system}.
        Either build on a ${targetSystem} or set `onlyBinary = true`.
      ''
    else if pythonVersion != interpreterVersion then
      throw ''
        Attempt to use the fetchPythonRequirements package from python ${interpreterVersion},
        while `pythonVersion = ${pythonVersion}` was specified.
        Make sure to update the 'outputHash' after changing.
      ''
    else
    let
      # map nixos system strings to python platforms
      sysToPlatforms = {
        "x86_64-linux" = [
          "manylinux1_x86_64"
          "manylinux2010_x86_64"
          "manylinux2014_x86_64"
          "linux_x86_64"
        ];
        "x86_64-darwin" =
          lib.forEach (lib.range 0 15) (minor: "macosx_10_${builtins.toString minor}_x86_64");
        "aarch64-linux" = [
          "manylinux1_aarch64"
          "manylinux2010_aarch64"
          "manylinux2014_aarch64"
          "linux_aarch64"
        ];
      };

      platforms = if sysToPlatforms ? "${targetSystem}" then sysToPlatforms."${targetSystem}" else throw ''
        'binaryOnly' fetching is currently not supported for target ${targetSystem}.
        You could set 'binaryOnly = false' and execute the build on a ${targetSystem}.
      '';

      # fixed output derivation containing downloaded packages,
      # each being symlinked from it's normalized name
      # Example:
      #   "$out/werkzeug" will point to "$out/Werkzeug-0.14.1-py2.py3-none-any.whl"
      self = stdenv.mkDerivation {

        name = "python-sources-${targetSystem}";

        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        inherit outputHash;

        nativeBuildInputs = [ pythonWithMitmproxy curl cacert ];

        dontUnpack = true;
        dontInstall = true;
        dontFixup = true;

        buildPhase = ''
          # the script.py will read this date
          export MAX_DATE=${builtins.toString maxDate}
          pretty=$(python -c '
          import os; import dateutil.parser;
          try:
            print(int(os.getenv("MAX_DATE")))
          except ValueError:
            print(dateutil.parser.parse(os.getenv("MAX_DATE")))
          ')
          echo "selected maximum release date for python packages: $pretty"

          # find free port for proxy
          proxyPort=$(python -c '\
          import socket
          s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
          s.bind(("", 0))
          print(s.getsockname()[1])
          s.close()')

          # start proxy to filter pypi responses
          # mitmproxy wants HOME set
          # mitmdump == mitmproxy without GUI
          HOME=$(pwd) ${pythonWithMitmproxy}/bin/mitmdump \
            --listen-port "$proxyPort" \
            --ignore-hosts '.*files.pythonhosted.org.*'\
            --script ${./filter-pypi-responses.py} &

          # install specified version of pip first to ensure reproducible resolver logic
          ${python}/bin/python -m venv .venv
          .venv/bin/pip install --upgrade pip==${pipVersion}
          fetcherPip=.venv/bin/pip

          # wait for proxy to come up
          while sleep 0.5; do
            timeout 5 curl -fs --proxy http://localhost:$proxyPort http://pypi.org && break
          done

          mkdir $out

          # make pip query pypi through the filtering proxy
          $fetcherPip download \
            --no-cache \
            --dest $out \
            --progress-bar off \
            --proxy http://localhost:$proxyPort \
            --trusted-host pypi.org \
            --trusted-host files.pythonhosted.org \
            ${lib.concatStringsSep " " pipFlags} \
            ${lib.optionalString onlyBinary "--only-binary :all: ${
              lib.concatStringsSep " " (lib.forEach platforms (pf: "--platform ${pf}"))
            }"} \
            "${lib.concatStringsSep "\" \"" requirements}"

          # create symlinks to allow files being referenced via their normalized package names
          # Example:
          #   "$out/werkzeug" will point to "$out/Werkzeug-0.14.1-py2.py3-none-any.whl"
          cd $out
          for f in $(ls $out); do
            if [[ "$f" == *.whl ]]; then
              pname=$(echo "$f" | cut -d "-" -f 1 | sed -e 's/_/-/' -e 's/\./-/' -e 's/\(.*\)/\L\1/')
            else
              pname=$(echo "''${f%-*}" | sed -e 's/_/-/' -e 's/\./-/' -e 's/\(.*\)/\L\1/')
            fi
            echo "linking $pname to $f"
            ln -s "$f" "$pname"
          done

        '';
      };
    in self;
in

fetchPythonRequirements
