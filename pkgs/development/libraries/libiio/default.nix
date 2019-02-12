{ stdenv, fetchFromGitHub
, cmake, flex, bison
, libxml2, python
}:

stdenv.mkDerivation rec {
  name = "libiio-${version}";
  version = "0.17";

  src = fetchFromGitHub {
    owner  = "analogdevicesinc";
    repo   = "libiio";
    rev    = "refs/tags/v${version}";
    sha256 = "15lghy0zlq667abs1ggbvmb1qiw7vzhhzkw8dm9vzix4ffma2igg";
  };

  outputs = [ "out" "lib" "dev" "python" ];

  nativeBuildInputs = [ cmake flex bison ];
  buildInputs = [ libxml2 ];

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
