{ lib, buildPythonPackage, fetchFromGitHub, isPy27
, numpy
, pytest
}:

buildPythonPackage rec {
  version = "1.9.3";
  pname = "gsd";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "glotzerlab";
    repo = pname;
    rev = "v${version}";
    sha256 = "07hw29r2inyp493dia4fx3ysfr1wxi2jb3n9cmwdi0l54s2ahqvf";
  };

  propagatedBuildInputs = [ numpy ];

  checkInputs = [ pytest ];
  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "General simulation data file format";
    homepage = "https://github.com/glotzerlab/gsd";
    license = licenses.bsd2;
    maintainers = [ maintainers.costrouc ];
  };
}
