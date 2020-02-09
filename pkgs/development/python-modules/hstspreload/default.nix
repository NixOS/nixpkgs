{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
}:

buildPythonPackage rec {
  pname = "hstspreload";
  version = "2020.2.5";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "sethmlarson";
    repo = pname;
    rev = version;
    sha256 = "1jz4qma04vkiczlj0fd9ahjf6c3yxvycvhp48c3n3l4aw4gfsbiz";
  };

  # tests require network connection
  doCheck = false;

  meta = with lib; {
    description = "Chromium HSTS Preload list as a Python package and updated daily";
    homepage = https://github.com/sethmlarson/hstspreload;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
