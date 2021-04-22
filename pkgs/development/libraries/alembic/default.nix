{ lib, stdenv, fetchFromGitHub, unzip, cmake, openexr, hdf5-threadsafe }:

stdenv.mkDerivation rec
{
  pname = "alembic";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "alembic";
    repo = "alembic";
    rev = version;
    sha256 = "sha256-c4SN3kNY8415+O/2AYuHNQFEmuTBtLaWj5fsj0yJ2vs=";
  };

  outputs = [ "bin" "dev" "out" "lib" ];

  nativeBuildInputs = [ unzip cmake ];
  buildInputs = [ openexr hdf5-threadsafe ];

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

  meta = with lib; {
    description = "An open framework for storing and sharing scene data";
    homepage = "http://alembic.io/";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = [ maintainers.guibou ];
  };
}
