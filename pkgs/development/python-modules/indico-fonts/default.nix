{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonPackage rec {
  pname = "indico-fonts";
  version = "1.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bwEh+VYRY2ZXjgR2s+KhZWwUexgMb3C8EXhok23KAD0=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  pythonImportsCheck = [ "indico_fonts" ];

  meta = with lib; {
    description = "Indico - Binary fonts";
    homepage = "https://pypi.org/project/indico-fonts/";
    license = with licenses; [ arphicpl ofl wadalab ];
    maintainers = with maintainers; [ thubrecht ];
    mainProgram = "indico-fonts";
  };
}
