{ stdenv, fetchFromGitHub
, cmake, flex, bison
, libxml2, python
, libusb1, runtimeShell
}:

stdenv.mkDerivation rec {
  name = "libiio-${version}";
  version = "0.18";

  src = fetchFromGitHub {
    owner  = "analogdevicesinc";
    repo   = "libiio";
    rev    = "refs/tags/v${version}";
    sha256 = "1cmg3ipam101iy9yncwz2y48idaqaw4fg7i9i4c8vfjisfcycnkk";
  };

  outputs = [ "out" "lib" "dev" "python" ];

  nativeBuildInputs = [ cmake flex bison ];
  buildInputs = [ libxml2 libusb1 ];

  postPatch = ''
    substituteInPlace libiio.rules.cmakein \
      --replace /bin/sh ${runtimeShell}
  '';

  # since we can't expand $out in cmakeFlags
  preConfigure = ''
    cmakeFlags="$cmakeFlags -DUDEV_RULES_INSTALL_DIR=$out/etc/udev/rules.d"
  '';

  postInstall = ''
    mkdir -p $python/lib/${python.libPrefix}/site-packages/
    touch $python/lib/${python.libPrefix}/site-packages/
    cp ../bindings/python/iio.py $python/lib/${python.libPrefix}/site-packages/

    substitute ../bindings/python/iio.py $python/lib/${python.libPrefix}/site-packages/iio.py \
      --replace 'libiio.so.0' $lib/lib/libiio.so.0
  '';

  meta = with stdenv.lib; {
    description = "API for interfacing with the Linux Industrial I/O Subsystem";
    homepage    = https://github.com/analogdevicesinc/libiio;
    license     = licenses.lgpl21;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
