{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook, testers }:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfyaml";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "pantoniou";
    repo = "libfyaml";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Id5pdFzjA9q67okfESO3LZH8jIz93mVgIEEuBbPjuGI=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  outputs = [ "bin" "dev" "out" "man" ];

  configureFlags = [ "--disable-network" ];

  doCheck = true;

  preCheck = ''
    patchShebangs test
  '';

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "Fully feature complete YAML parser and emitter, supporting the latest YAML spec and passing the full YAML testsuite";
    homepage = "https://github.com/pantoniou/libfyaml";
    changelog = "https://github.com/pantoniou/libfyaml/releases/tag/v${finalAttrs.version}";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    pkgConfigModules = [ "libfyaml" ];
    platforms = platforms.all;
  };
})
