{ stdenv, fetchFromGitHub, unzip, cmake, freeglut, libGLU_combined, zlib, swig, python, doxygen, xorg }:

stdenv.mkDerivation rec
{
  name = "partio-${version}";
  version = "2018-03-01";

  src = fetchFromGitHub {
    owner = "wdas";
    repo = "partio";
    rev = "8b6ea0d20f1ab77cd7f18390999251e60932de4a";
    sha256 = "16sdj103v02l2dgq9y9cna9jakafabz9jxzdxsd737ir6wn10ksb";
  };

  outputs = [ "dev" "out" "lib" ];

  nativeBuildInputs = [ unzip cmake doxygen ];
  buildInputs = [ freeglut libGLU_combined zlib swig python xorg.libXi xorg.libXmu ];

  enableParallelBuilding = true;

  buildPhase = ''
    make partio

    mkdir $dev
    mkdir $out
      '';

  # TODO:
  # Sexpr support

  installPhase = ''
    make install prefix=$out
    mkdir $dev/include/partio
    mv $dev/include/*.h $dev/include/partio
  '';

  meta = with stdenv.lib; {
    description = "C++ (with python bindings) library for easily reading/writing/manipulating common animation particle formats such as PDB, BGEO, PTC";
    homepage = "https://www.disneyanimation.com/technology/partio.html";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.guibou ];
  };
}
