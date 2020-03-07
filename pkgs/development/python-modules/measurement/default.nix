{ lib, fetchFromGitHub, buildPythonPackage, isPy3k
, sympy, pytest, pytestrunner, sphinx, setuptools_scm }:

buildPythonPackage rec {
  pname = "measurement";
  version = "3.2.0";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "coddingtonbear";
    repo = "python-measurement";
    rev = version;
    sha256 = "1mk9qg1q4cnnipr6xa72i17qvwwhz2hd8p4vlsa9gdzrcv4vr8h9";
  };

  postPatch = ''
    sed -i 's|use_scm_version=True|version="${version}"|' setup.py
  '';

  checkInputs = [ pytest pytestrunner ];
  nativeBuildInputs = [ sphinx setuptools_scm ];
  propagatedBuildInputs = [ sympy ];

  meta = with lib; {
    description = "Use and manipulate unit-aware measurement objects in Python";
    homepage = https://github.com/coddingtonbear/python-measurement;
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
