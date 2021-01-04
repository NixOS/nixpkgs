{ stdenv
, callPackage
, python27Packages
, installShellFiles
, fetchFromGitHub
, file
, findutils
, gettext
, bats
, bash
, doCheck ? true
}:
let
  version = "0.4.0";
  rSrc = fetchFromGitHub {
    owner = "abathur";
    repo = "resholve";
    rev = "v${version}";
    hash = "sha256-wfxcX3wMZqoi5bWjXYRa21UDDJmTDfE+21p4mL2IJog=";
  };
  deps = callPackage ./deps.nix {
    /*
    resholve needs to patch Oil, but trying to avoid adding
    them all *to* nixpkgs, since they aren't specific to
    nix/nixpkgs.
    */
    oilPatches = [
      "${rSrc}/0001-add_setup_py.patch"
      "${rSrc}/0002-add_MANIFEST_in.patch"
      "${rSrc}/0003-fix_codegen_shebang.patch"
      "${rSrc}/0004-disable-internal-py-yajl-for-nix-built.patch"
    ];
  };
in
python27Packages.buildPythonApplication {
  pname = "resholve";
  inherit version;
  src = rSrc;
  format = "other";

  nativeBuildInputs = [ installShellFiles ];

  propagatedBuildInputs = [ deps.oildev python27Packages.ConfigArgParse ];

  patchPhase = ''
    for file in resholve; do
      substituteInPlace $file --subst-var-by version ${version}
    done
  '';

  installPhase = ''
    install -Dm755 resholve $out/bin/resholve
    installManPage resholve.1
  '';

  inherit doCheck;
  checkInputs = [ bats ];
  RESHOLVE_PATH = "${stdenv.lib.makeBinPath [ file findutils gettext ]}";

  checkPhase = ''
    # explicit interpreter for test suite
    export INTERP="${bash}/bin/bash" PATH="$out/bin:$PATH"
    patchShebangs .
    ./test.sh
  '';

  meta = with stdenv.lib; {
    description = "Resolve external shell-script dependencies";
    homepage = "https://github.com/abathur/resholve";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ abathur ];
    platforms = platforms.all;
  };
}
