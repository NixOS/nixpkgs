{ lib
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
  version = "0.5.1";
  rSrc = fetchFromGitHub {
    owner = "abathur";
    repo = "resholve";
    rev = "v${version}";
    hash = "sha256-+9MjvO1H+A3Ol2to5tWqdpNR7osQsYcbkX9avAqyrKw=";
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
      "${rSrc}/0005_revert_libc_locale.patch"
      "${rSrc}/0006_disable_failing_libc_tests.patch"
      "${rSrc}/0007_restore_root_init_py.patch"
    ];
  };
in
python27Packages.buildPythonApplication {
  pname = "resholve";
  inherit version;
  src = rSrc;
  format = "other";

  nativeBuildInputs = [ installShellFiles ];

  propagatedBuildInputs = [ deps.oildev python27Packages.configargparse ];

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
  RESHOLVE_PATH = "${lib.makeBinPath [ file findutils gettext ]}";

  checkPhase = ''
    # explicit interpreter for test suite
    export INTERP="${bash}/bin/bash" PATH="$out/bin:$PATH"
    patchShebangs .
    ./test.sh
  '';

  # Do not propagate Python; may be obsoleted by nixos/nixpkgs#102613
  # for context on why, see abathur/resholve#20
  postFixup = ''
    rm $out/nix-support/propagated-build-inputs
  '';

  meta = with lib; {
    description = "Resolve external shell-script dependencies";
    homepage = "https://github.com/abathur/resholve";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ abathur ];
    platforms = platforms.all;
  };
}
