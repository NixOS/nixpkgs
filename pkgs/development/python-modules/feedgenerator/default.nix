{ lib, buildPythonPackage, glibcLocales, fetchPypi, six, pytz }:

buildPythonPackage rec {
  pname = "feedgenerator";
  version = "1.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b06d6941e8fd6a2c9e71791079e86cbe7a3788c72244acc06f0593b49cda379b";
  };

  buildInputs = [ glibcLocales ];

  LC_ALL="en_US.UTF-8";

  propagatedBuildInputs = [ six pytz ];

  meta = with lib; {
    description = "Standalone version of django.utils.feedgenerator, compatible with Py3k";
    homepage = "https://github.com/dmdm/feedgenerator-py3k.git";
    maintainers = with maintainers; [ ];
  };
}
