{ stdenv
, buildPythonPackage
, fetchFromGitHub
, pytest
}:

buildPythonPackage rec {
  pname = "apply_defaults";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "bcb";
    repo = pname;
    rev = version;
    sha256 = "1nn2mch5spq8mhk741ia7zkb2bgjfn7bzxpavb476jzs38pb39d5";
  };

  checkInputs = [ pytest ];
  checkPhase = "pytest";

  meta = with stdenv.lib; {
    description = "Apply values to optional params";
    homepage = "https://github.com/bcb/apply_defaults";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };

}
