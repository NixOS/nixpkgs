{ stdenv, lib, buildPythonPackage, fetchPypi, pytz, pytest, freezegun, glibcLocales }:

buildPythonPackage rec {
  pname = "Babel";
  version = "2.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e86135ae101e31e2c8ec20a4e0c5220f4eed12487d5cf3f78be7e98d3a57fc28";
  };

  propagatedBuildInputs = [ pytz ];

  checkInputs = [ pytest freezegun ];

  # Note that a test will fail with an encoding error on Python 2 with Nix < 2.3
  # due to https://github.com/NixOS/nixpkgs/pull/75676#issuecomment-579008837.
  # TODO: Remove the above comment when we use a version that includes the fix
  #       from https://github.com/python-babel/babel/pull/691
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    homepage = http://babel.edgewall.org;
    description = "A collection of tools for internationalizing Python applications";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
