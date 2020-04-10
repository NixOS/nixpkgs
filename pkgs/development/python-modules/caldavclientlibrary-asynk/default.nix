{ stdenv
, buildPythonPackage
, fetchgit
, isPy3k
}:

buildPythonPackage {
  version = "asynkdev";
  pname = "caldavclientlibrary-asynk";

  src = fetchgit {
    url = "https://github.com/skarra/CalDAVClientLibrary.git";
    rev = "06699b08190d50cc2636b921a654d67db0a967d1";
    sha256 = "157q32251ac9x3gdshgrjwsy48nq74vrzviswvph56h9wa8ksnnk";
  };

  disabled = isPy3k;

  meta = with stdenv.lib; {
    description = "A Python library and tool for CalDAV";

    longDescription = ''
      CalDAVCLientLibrary is a Python library and tool for CalDAV.

      This package is the unofficial CalDAVCLientLibrary Python
      library maintained by the author of Asynk and is needed for
      that package.
    '';

    homepage = "https://github.com/skarra/CalDAVClientLibrary/tree/asynkdev/";
    maintainers = with maintainers; [ pjones ];
    broken = true; # 2018-04-11
  };

}
