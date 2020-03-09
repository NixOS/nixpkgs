{stdenv, fetchFromGitHub, rebar, erlang, opencl-headers, ocl-icd }:

stdenv.mkDerivation rec {
  version = "1.2.4";
  pname = "cl";

  src = fetchFromGitHub {
    owner = "tonyrog";
    repo = "cl";
    rev = "cl-${version}";
    sha256 = "1gwkjl305a0231hz3k0w448dsgbgdriaq764sizs5qfn59nzvinz";
  };

  buildInputs = [ erlang rebar opencl-headers ocl-icd ];

  buildPhase = ''
    rebar compile
  '';

  # 'cp' line taken from Arch recipe
  # https://projects.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/erlang-sdl
  installPhase = ''
    DIR=$out/lib/erlang/lib/${pname}-${version}
    mkdir -p $DIR
    cp -ruv c_src doc ebin include priv src $DIR
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/tonyrog/cl;
    description = "OpenCL binding for Erlang";
    license = licenses.mit;
    # https://github.com/tonyrog/cl/issues/39
    broken = stdenv.isAarch64;
    platforms = platforms.linux;
  };
}
