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
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b20a4aeac9079b194f0160957d4265bb6c99ce68f1b12e980b0fb96f74aafb70";
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
