{ stdenv, lib, fetchFromGitHub, cmake, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "pe-parse";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "pe-parse";
    rev = "v${version}";
    hash = "sha256-HwWlMRhpB/sa/JRyAZF7LZzkXCCyuxB+gtDAfHt7e6k=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/trailofbits/pe-parse/commit/eecdb3d36eb44e306398a2e66e85490f9bdcc74c.patch";
      hash = "sha256-pd6D/JMctiQqJxnJU9Nm/GDVf4/CaIGeXx1UfdcCupo=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/dump-pe ../tests/assets/example.exe
  '';

  meta = with lib; {
    description = "A principled, lightweight parser for Windows portable executable files";
    homepage = "https://github.com/trailofbits/pe-parse";
    license = licenses.mit;
    maintainers = with maintainers; [ arturcygan ];
    mainProgram = "dump-pe";
    platforms = platforms.unix;
  };
}
