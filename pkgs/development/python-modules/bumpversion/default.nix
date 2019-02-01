{ stdenv, lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "bumpversion";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "peritus";
    repo = pname;
    rev = "v${version}";
    sha256 = "08zjxa9k15jrvjy7j7qbwjkggcisbx2x4yh5rva4slnjrk3qhmx8";
  };

  # checkInputs = [ pytest mock git mercurial ];
  # stuck at `AttributeError: module 'enum' has no attribute 'IntFlag'`
  doCheck = false;

  meta = with lib; {
    description = "Version-bump your software with a single command";
    homepage = https://github.com/peritus/bumpversion;
    maintainers = with maintainers; [ peterromfeldhk ];
    license = with licenses; [ mit ];
  };
}
