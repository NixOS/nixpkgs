{ lib, buildPythonPackage, fetchFromGitHub}:

buildPythonPackage rec {
  pname = "gorilla";
  version = "0.4.0";

  src = fetchFromGitHub {
     owner = "christophercrouzet";
     repo = "gorilla";
     rev = "v0.4.0";
     sha256 = "1dr4qm5k15s7a8la2isg686fms6hhc94giyjmdjgzlyzswf050hc";
  };

  meta = with lib; {
    homepage = "https://github.com/christophercrouzet/gorilla";
    description = "Convenient approach to monkey patching";
    license = licenses.mit;
    maintainers = with maintainers; [ tbenst ];
  };
}
