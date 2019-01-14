{ pkgs
, buildPythonPackage
, fetchPypi
, six
, nose
, appdirs
, scandir
, backports_os
, typing
, pytz
, enum34
, pyftpdlib
, psutil
, mock
, pythonAtLeast
, isPy3k
}:

buildPythonPackage rec {
  pname = "fs";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2581685468e0e492466170235e1bcda5ed4359c69607c83935afee7d4945ad2d";
  };

  buildInputs = [ pkgs.glibcLocales ];
  checkInputs = [ nose pyftpdlib mock psutil ];
  propagatedBuildInputs = [ six appdirs pytz ]
    ++ pkgs.lib.optionals (!isPy3k) [ backports_os ]
    ++ pkgs.lib.optionals (!pythonAtLeast "3.6") [ typing ]
    ++ pkgs.lib.optionals (!pythonAtLeast "3.5") [ scandir ]
    ++ pkgs.lib.optionals (!pythonAtLeast "3.5") [ enum34 ];

  postPatch = ''
    # required for installation
    touch LICENSE
    # tests modify home directory results in (4 tests failing) / 1600
    rm tests/test_appfs.py tests/test_opener.py
  '';

  LC_ALL="en_US.utf-8";

  meta = with pkgs.lib; {
    description = "Filesystem abstraction";
    homepage    = https://github.com/PyFilesystem/pyfilesystem2;
    license     = licenses.bsd3;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };

}
