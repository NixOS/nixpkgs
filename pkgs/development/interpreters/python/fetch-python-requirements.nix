# fetchPythonRequirements downlaods python packages specified by a list of
# pip-style python requirements
# It also requires a maximum date 'maxDate' being specified.
# The result will be as if `pip download` would have been executed
# at the point in time specified by maxDate.
# This is ensured by putting pip behind a local proxy filtering the
# api responses from pypi.org to only contain files for which the
# release date is lower than the specified maxDate.

{
  # this specifies the python version for which the packages should be downloaded
  python,
}:

{
  lib
, cacert
, curl
, stdenv
, buildPackages
, python3
, ...
}:
let

  # we use mitmproxy to filter the pypi responses
  pythonWithMitmproxy = python3.withPackages (ps: [ ps.mitmproxy ps.python-dateutil ]);

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

    # Throw an error by default to warn the user about the correct usage
    targetSystem ? throw ''
      'targetSystem' must be specified for fetchPythonRequirements.
      Pass only a constant string like for example "x86_64-linux".
      Do not pass `stdenv.targetPlatform.system` or `builtins.currentSystem`.
      This prevents the fetcher from being executed on the wrong platform.
    '',
  }:

    # specifying `--platform` for pip download is only allowed in combination with `--only-binary :all:`
    # therefore, if onlyBinary is disabled, we must enforce targetPlatform == buildPlatform to ensure reproducibility
    if ! onlyBinary && targetSystem != stdenv.buildPlatform.system then
      throw ''
        fetchPythonRequirements cannot fetch sdist packages for ${targetSystem} on a ${stdenv.buildPlatform.system}.
        Either build on a ${targetSystem} or set `onlyBinary = true`.
      ''
    else
    let
      # map nixos system strings to python platforms
      sysToPlatforms = {
        "x86_64-linux" = [
          "manylinux1_x86_64"
          "manylinux2010_x86_64"
          "manylinux2014_x86_64"
        ];
        "x86_64-darwin" =
          lib.forEach (lib.range 0 15) (minor: "macosx_10_${builtins.toString minor}_x86_64");
        "aarch64-linux" = [
          "manylinux1_aarch64"
          "manylinux2010_aarch64"
          "manylinux2014_aarch64"
        ];
      };
      platforms = if sysToPlatforms ? "${targetSystem}" then sysToPlatforms."${targetSystem}" else throw ''
        'binaryOnly' fetching is currently not supported for target ${targetSystem}.
        You could set 'binaryOnly = false' and execute the build on a ${targetSystem}.
      '';

      pythonAttrName = lib.stringAsChars (x: if x == "." then "" else x) python.libPrefix;

      # We need to execute pip from the python version for which we want to download packages.
      # Pip accepts '--python-version', but this works only for wheel packages.
      pythonPip = buildPackages."${pythonAttrName}".withPackages (ps: [
        ps.pip
        ps.setuptools
        ps.pkgconfig
      ]);

      # Normalize package names:
      #   "Example_Package[extra]" -> "example-package"
      normalizedNames = map (req:
        lib.toLower (lib.replaceStrings [ "_" ] [ "-" ] (lib.elemAt (lib.splitString "[" req) 0))
      ) requirements;

      # fixed output derivation containing packages,
      # each being symlinked from it's normalized name
      # Example:
      #   "$out/werkzeug" will point to "$out/Werkzeug-0.14.1-py2.py3-none-any.whl"
      self = stdenv.mkDerivation {

        name = "python-sources-${targetSystem}";

        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        inherit outputHash;

        nativeBuildInputs = with python3.pkgs; [ pythonWithMitmproxy pythonPip curl cacert ];

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
          HOME=$(pwd) mitmdump \
            --listen-port "$proxyPort" \
            --ignore-hosts '.*files.pythonhosted.org.*'\
            --script ${./filter-pypi-responses.py} &

          # wait for proxy to come up
          while sleep 0.5; do
            timeout 5 curl --fail --proxy http://localhost:$proxyPort http://pypi.org 2>/dev/null && break
          done

          mkdir $out

          # make pip query pypi through the filtering proxy
          ${pythonPip}/bin/pip download \
            --no-cache \
            --dest $out \
            --proxy http://localhost:$proxyPort \
            --trusted-host pypi.org \
            --trusted-host files.pythonhosted.org \
            ${lib.concatStringsSep " " pipFlags} \
            ${lib.optionalString onlyBinary "--only-binary :all: ${
              lib.concatStringsSep " " (lib.forEach platforms (pf: "--platform ${pf}"))
            }"} \
            "${lib.concatStringsSep "\" \"" requirements}"

          # create symlinks to allow files being referenced via their normalized package names
          cd $out
          for f in $(ls $out); do
            if [[ "$f" == *.whl ]]; then
              pname=$(echo "$f" | cut -d "-" -f 1 | sed 's/_/-/' | sed 's/\(.*\)/\L\1/')
            else
              pname=''${f%-*}
            fi
            echo "linking $pname to $f"
            ln -s "$f" "$pname"
          done

        '';
      };
    in self;
in

fetchPythonRequirements


