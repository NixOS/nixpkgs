{stdenv, fetchurl, SDL, mesa, rebar, erlang, opencl-headers, ocl-icd }:

stdenv.mkDerivation rec {
  version = "1.2.1";
  name = "cl-${version}";

  src = fetchurl {
    url = "https://github.com/tonyrog/cl/archive/${name}.tar.gz";
    sha256 = "03jv280h9gqqqkm0mmkjr53srd2mzhvyy1biss77wpjrzq2z12c8";
  };

  buildInputs = [ erlang rebar opencl-headers ocl-icd ];
  #propagatedBuildInputs = [ SDL mesa ];

  buildPhase = ''
    sed 's/git/"${version}"/' -i src/cl.app.src
    rebar compile
  '';

  # 'cp' line taken from Arch recipe
  # https://projects.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/erlang-sdl
  installPhase = ''
    DIR=$out/lib/erlang/lib/${name}
    mkdir -p $DIR
    cp -ruv c_src doc ebin include priv src $DIR
  '';

  meta = {
    homepage = https://github.com/tonyrog/cl;
    description = "OpenCL binding for Erlang";
    license = stdenv.lib.licences.mit;
  };
}
