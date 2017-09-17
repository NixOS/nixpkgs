{ stdenv, fetchFromGitHub, unzip, cmake, openexr, hdf5 }:

stdenv.mkDerivation rec
{
  name = "alembic-${version}";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "alembic";
    repo = "alembic";
    rev = "${version}";
    sha256 = "00r6d8xk2sq5hdl5lp14nhyh1b2d68fxpzbm69fk6iq2f2gv0iqv";
  };

  outputs = [ "bin" "dev" "out" "lib" ];

  buildInputs = [ unzip cmake openexr hdf5 ];

  sourceRoot = "${name}-src";

  enableParallelBuilding = true;

  buildPhase = ''
    cmake -DUSE_HDF5=ON -DCMAKE_INSTALL_PREFIX=$out/ -DUSE_TESTS=OFF .

    mkdir $out
    mkdir -p $bin/bin
    mkdir -p $dev/include
    mkdir -p $lib/lib
  '';

  installPhase = ''
    make install

    mv $out/bin $bin/
    mv $out/lib $lib/
    mv $out/include $dev/
  '';

  meta = with stdenv.lib; {
    description = "An open framework for storing and sharing scene data";
    homepage = "http://alembic.io/";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = [ maintainers.guibou ];
  };
}
