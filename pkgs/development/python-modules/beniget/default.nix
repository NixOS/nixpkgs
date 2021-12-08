{ lib
, buildPythonPackage
, fetchFromGitHub
, gast
}:

buildPythonPackage rec {
  pname = "beniget";
  version = "0.4.1";

  src = fetchFromGitHub {
     owner = "serge-sans-paille";
     repo = "beniget";
     rev = "0.4.1";
     sha256 = "0zamp3a3qxs47lwd8sr89pa0w20hfri34k0r4dr07wg6fgk1jv52";
  };

  propagatedBuildInputs = [
    gast
  ];

  meta = {
    description = "Extract semantic information about static Python code";
    homepage = "https://github.com/serge-sans-paille/beniget";
    license = lib.licenses.bsd3;
  };
}
