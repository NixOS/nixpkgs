{ lib, buildPythonPackage, fetchurl, fetchpatch
, pytest, werkzeug, pygments
}:

buildPythonPackage rec {
  name = "moinmoin-${ver}";
  ver = "1.9.9";

  src = fetchurl {
    url = "http://static.moinmo.in/files/moin-${ver}.tar.gz";
    sha256 = "197ga41qghykmir80ik17f9hjpmixslv3zjgj7bj9qvs1dvdg5s3";
  };

  patches = [
    # Recommended to install on their download page.
    (fetchpatch {
      url = "https://bitbucket.org/thomaswaldmann/moin-1.9/commits/561b7a9c2bd91b61d26cd8a5f39aa36bf5c6159e/raw";
      sha256 = "1nscnl9nspnrwyf3n95ig0ihzndryinq9kkghliph6h55cncfc65";
    })
    ./fix_tests.patch
  ];

  checkInputs = [ pytest werkzeug pygments ];

  meta = with lib; {
    description = "Advanced, easy to use and extensible WikiEngine";

    homepage = "http://moinmo.in/";

    license = licenses.gpl2Plus;
  };
}
