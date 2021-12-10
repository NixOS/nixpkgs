{ buildPythonPackage, lib, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "fields";
  version = "5.0.0";

  src = fetchFromGitHub {
     owner = "ionelmc";
     repo = "python-fields";
     rev = "v5.0.0";
     sha256 = "0jzf90i3sig9alm96jvp8l0i5mpvwzqwbi0kgjsb69n6dca3nbnc";
  };

  pythonImportsCheck = [ "fields" ];

  meta = with lib; {
    description = "Container class boilerplate killer";
    homepage = "https://github.com/ionelmc/python-fields";
    license = licenses.bsd2;
    maintainers = [ maintainers.sheepforce ];
  };
}
