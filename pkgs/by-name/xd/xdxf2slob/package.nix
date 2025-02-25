{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication {
  pname = "xdxf2slob";
  version = "unstable-2015-06-30";

  src = fetchFromGitHub {
    owner = "itkach";
    repo = "xdxf2slob";
    rev = "6831b93c3db8c73200900fa4ddcb17350a677e1b";
    sha256 = "0m3dnc3816ja3kmik1wabb706dkqdf5sxvabwgf2rcrq891xcddd";
  };

  propagatedBuildInputs = [
    python3Packages.pyicu
    python3Packages.slob
  ];

  meta = with lib; {
    description = "Tool to convert XDXF dictionary files to slob format";
    homepage = "https://github.com/itkach/xdxf2slob/";
    license = licenses.gpl3;
    platforms = platforms.all;
    mainProgram = "xdxf2slob";
  };
}
