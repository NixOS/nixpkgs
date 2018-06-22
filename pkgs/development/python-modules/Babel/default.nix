{ lib, buildPythonPackage, fetchPypi, pytz, pytest, freezegun, glibcLocales }:

buildPythonPackage rec {
  pname = "Babel";
  version = "2.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8cba50f48c529ca3fa18cf81fa9403be176d374ac4d60738b839122dfaaa3d23";
  };

  propagatedBuildInputs = [ pytz ];

  checkInputs = [ pytest freezegun glibcLocales ];

  preCheck = ''
    export LC_ALL="en_US.UTF-8"
  '';

  meta = with lib; {
    homepage = http://babel.edgewall.org;
    description = "A collection of tools for internationalizing Python applications";
    license = licenses.bsd3;
    maintainers = with maintainers; [ garbas ];
  };
}
