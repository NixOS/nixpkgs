{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "btrfs";
  version = "11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1w92sj47wy53ygz725xr613k32pk5khi0g9lrpp6img871241hrx";
  };

  meta = with stdenv.lib; {
    description = "Inspect btrfs filesystems";
    homepage = "https://github.com/knorrie/python-btrfs";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.evils ];
  };
}
