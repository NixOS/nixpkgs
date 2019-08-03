{ stdenv
, buildPythonPackage
, fetchurl
, six
, isPyPy
}:

buildPythonPackage rec {
  pname = "jsonwatch";
  version = "0.2.0";
  disabled = isPyPy; # doesn't find setuptools

  src = fetchurl {
    url = "https://github.com/dbohdan/jsonwatch/archive/v0.2.0.tar.gz";
    sha256 = "04b616ef97b9d8c3887004995420e52b72a4e0480a92dbf60aa6c50317261e06";
  };

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Like watch -d but for JSON";
    longDescription = ''
      jsonwatch is a command line utility with which you can track
      changes in JSON data delivered by a shell command or a web
      (HTTP/HTTPS) API.  jsonwatch requests data from the designated
      source repeatedly at a set interval and displays the
      differences when the data changes. It is similar in its
      behavior to how watch(1) with the -d switch works for
      plain-text data.
    '';
    homepage = "https://github.com/dbohdan/jsonwatch";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
