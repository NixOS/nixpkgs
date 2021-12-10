{ lib, buildPythonPackage, fetchFromGitHub, flask }:

buildPythonPackage rec {
  pname = "flask-paginate";
  version = "2021.10.29";

  src = fetchFromGitHub {
     owner = "lixxu";
     repo = "flask-paginate";
     rev = "v2021.10.29";
     sha256 = "0n55yxh7irj3lghrcx1670n8fj3qkshvplpf74ihpflfcmr5xqzh";
  };

  propagatedBuildInputs = [ flask ];

  meta = with lib; {
    homepage = "https://github.com/lixxu/flask-paginate";
    description = "Pagination support for Flask";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
