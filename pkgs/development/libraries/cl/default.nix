{stdenv, fetchFromGitHub, SDL, mesa, rebar, erlang, opencl-headers, ocl-icd }:

stdenv.mkDerivation rec {
  version = "1.2.3";
  name = "cl-${version}";

  src = fetchFromGitHub {
    owner = "tonyrog";
    repo = "cl";
    rev = "cl-${version}";
    sha256 = "1dk0k03z0ipxvrnn0kihph135hriw96jpnd31lbq44k6ckh6bm03";
  };

  buildInputs = [ erlang rebar opencl-headers ocl-icd ];
  
  buildPhase = ''
    rebar compile
  '';

  # 'cp' line taken from Arch recipe
  # https://projects.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/erlang-sdl
  installPhase = ''
    DIR=$out/lib/erlang/lib/${name}
    mkdir -p $DIR
    cp -ruv c_src doc ebin include priv src $DIR
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/tonyrog/cl;
    description = "OpenCL binding for Erlang";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
