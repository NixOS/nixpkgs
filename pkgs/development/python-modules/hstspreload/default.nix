{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
}:

buildPythonPackage rec {
  pname = "hstspreload";
  version = "2020.12.22";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "sethmlarson";
    repo = pname;
    rev = version;
    sha256 = "1jzcw4clmpbyw67pzskms5rq5b7285iwh42jzc4ly6jz9amggdzc";
  };

  # tests require network connection
  doCheck = false;

  pythonImportsCheck = [ "hstspreload" ];

  meta = with lib; {
    description = "Chromium HSTS Preload list as a Python package and updated daily";
    homepage = "https://github.com/sethmlarson/hstspreload";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
