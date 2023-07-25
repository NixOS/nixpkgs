{ lib, buildPythonPackage, fetchFromGitHub, python-slugify, jinja2, setuptools, coverage }:

buildPythonPackage rec {
  pname = "python-nvd3";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "areski";
    repo = "python-nvd3";
    rev = "dc8e772597ed72f413b229856fc9a3318e57fcfc";
    sha256 = "1vjnicszcc9j0rgb58104fk9sry5xad1xli64jana9bkx42c6x1v";
  };

  propagatedBuildInputs = [ python-slugify jinja2 setuptools ];
  nativeCheckInputs = [ coverage ];

  checkPhase = ''
    coverage run --source=nvd3 setup.py test
  '';

  meta = with lib; {
    homepage = "https://github.com/areski/python-nvd3";
    description = "Python Wrapper for NVD3 - It's time for beautiful charts";
    license = licenses.mit;
    maintainers = [ maintainers.ivan-tkatchev ];
  };
}
