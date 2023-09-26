{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook, testers }:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfyaml";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "pantoniou";
    repo = "libfyaml";
    rev = "v${finalAttrs.version}";
    hash = "sha256-b/jRKe23NIVSydoczI+Ax2VjBJLfAEwF8SW61vIDTwA=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  outputs = [ "bin" "dev" "out" "man" ];

  doCheck = true;

  preCheck = ''
    patchShebangs test
  '';

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
  };

  meta = with lib; {
    homepage = "https://github.com/pantoniou/libfyaml";
    description = "Fully feature complete YAML parser and emitter, supporting the latest YAML spec and passing the full YAML testsuite";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    pkgConfigModules = [ "libfyaml" ];
    platforms = platforms.all;
  };
})
