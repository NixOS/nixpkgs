{ stdenv, fetchurl, fetchFromGitHub, zlib, expat, cmake
, which, libxml2, python3
}:

stdenv.mkDerivation rec {
  name = "exiv2-${version}";
  version = "0.27";

  src = fetchFromGitHub rec {
    owner = "exiv2";
    repo  = "exiv2";
    rev = version;
    sha256 = "07gagwrankj9igjag95qhwn2cbj5g8n0m26xm9v7cwp0h16xr4a3";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ zlib expat ];

  enableParallelBuilding = true;

  doCheck = true;
  # Test setup found by inspecting ${src}/.travis/run.sh; problems without cmake.
  checkTarget = "tests";
  checkInputs = [ which libxml2.bin python3 ];
  preCheck = ''
    patchShebangs ../test/
    mkdir ../test/tmp
    export LD_LIBRARY_PATH="$(realpath ../build/lib)"
  '';
  postCheck = ''
    (cd ../tests/ && python3 runner.py)
  '';

  # With cmake it installs lots of additional stuff.
  postInstall = ''
    ( cd "$out/bin"
      mv exiv2 .exiv2
      rm *
      mv .exiv2 exiv2
    )
    rm "$out"/lib/libxmp.a
  '';

  meta = with stdenv.lib; {
    homepage = http://www.exiv2.org/;
    description = "A library and command-line utility to manage image metadata";
    platforms = platforms.all;
    license = licenses.gpl2Plus;
  };
}
