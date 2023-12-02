{ lib
, fetchDebianPatch
, fetchPypi
, buildPythonPackage
, m2crypto
}:

buildPythonPackage rec {
  pname = "pysimplesoap";
  # Unfortunately, the latest stable release is broken on Python 3.
  version = "1.16.2";

  src = fetchPypi {
    pname = "PySimpleSOAP";
    inherit version;
    hash = "sha256-sbv00NCt/5tlIZfWGqG3ZzGtYYhJ4n0o/lyyUJFtZ+E=";
  };

  propagatedBuildInputs = [
    m2crypto
  ];

  patches = map (args: fetchDebianPatch ({
    inherit pname version;
    debianRevision = "5";
  } // args)) [
    # Merged upstream: f5f96210e1483f81cb5c582a6619e3ec4b473027
    { patch = "Add-quotes-to-SOAPAction-header-in-SoapClient";
      hash = "sha256-xA8Wnrpr31H8wy3zHSNfezFNjUJt1HbSXn3qUMzeKc0="; }
    # Merged upstream: ad03a21cafab982eed321553c4bfcda1755182eb
    { patch = "fix-httplib2-version-check";
      hash = "sha256-zUeF3v0N/eMyRVRH3tQLfuUfMKOD/B/aqEwFh/7HxH4="; }
    { patch = "reorder-type-check-to-avoid-a-TypeError";
      hash = "sha256-2p5Cqvh0SPfJ8B38wb/xq7jWGYgpI9pavA6qkMUb6hA="; }
    # Merged upstream: 033e5899e131a2c1bdf7db5852f816f42aac9227
    { patch = "Support-integer-values-in-maxOccurs-attribute";
      hash = "sha256-IZ0DP7io+ihcnB5547cR53FAdnpRLR6z4J5KsNrkfaI="; }
    { patch = "PR204";
      hash = "sha256-JlxeTnKDFxvEMFBthZsaYRbNOoBvLJhBnXCRoiL/nVw="; }
  ] ++ [ ./stringIO.patch ];

  meta = with lib; {
    description = "Python simple and lightweight SOAP Library";
    homepage = "https://github.com/pysimplesoap/pysimplesoap";
    license = licenses.lgpl3Plus;

    # I don't directly use this, only needed it as a dependency of debianbts
    #  so co-maintainers would be welcome.
    maintainers = [ maintainers.nicoo ];
  };
}
