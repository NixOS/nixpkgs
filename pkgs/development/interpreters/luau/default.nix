{ lib, stdenv, fetchFromGitHub, cmake, llvmPackages, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "luau";
  version = "0.615";

  src = fetchFromGitHub {
    owner = "luau-lang";
    repo = "luau";
    rev = version;
    hash = "sha256-IwiPUiw3bH+9CzIAJqLjGpIBLQ+T0xW7c4jVXoxVZPc=";
  };

  patches = [
    # Fix linker errors. Remove with the next release.
    (fetchpatch {
      url = "https://github.com/luau-lang/luau/commit/9323be6110beda90ef9d9dcb43e49b9acdc224e5.patch";
      hash = "sha256-/uWXbv3ZSpGJ4Q9MYixz50o5HIp5keSaqMSlOq0TbzE=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.cc.isClang [ llvmPackages.libunwind ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin luau
    install -Dm755 -t $out/bin luau-analyze

    runHook postInstall
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    ./Luau.UnitTest
    ./Luau.Conformance

    runHook postCheck
  '';

  meta = with lib; {
    description = "A fast, small, safe, gradually typed embeddable scripting language derived from Lua";
    homepage = "https://luau-lang.org/";
    changelog = "https://github.com/luau-lang/luau/releases/tag/${version}";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.marsam ];
    mainProgram = "luau";
  };
}
