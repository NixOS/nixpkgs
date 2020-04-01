{ lib, rustPlatform, fetchFromGitHub, makeWrapper, z3 }:

rustPlatform.buildRustPackage rec {
  pname = "zz-unstable";
  version = "2020-03-02";

  src = fetchFromGitHub {
    owner = "aep";
    repo = "zz";
    rev = "2dd92b959f7c34bf99af84b263e3864a5c41a0fe";
    sha256 = "14ch5qgga2vpxvb53v4v4y6cwy3kkm10x1vbfpyfa7im57syib85";
  };

  nativeBuildInputs = [ makeWrapper ];

  cargoSha256 = "1m9az3adbkx2ab6fkg64cr7f9d73jbx8kx2pmgpw29csmh9hzqjy";

  postInstall = ''
    wrapProgram $out/bin/zz --prefix PATH ":" "${lib.getBin z3}/bin"
  '';

  meta = with lib; {
    description = "🍺🐙 ZetZ a zymbolic verifier and tranzpiler to bare metal C";
    homepage = "https://github.com/aep/zz";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
