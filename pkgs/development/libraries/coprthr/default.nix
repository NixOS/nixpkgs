{ stdenv, fetchurl, libelf, libconfig, libevent, which, unzip, perl, python
, bison, flex }:

stdenv.mkDerivation rec {
  name = "coprthr-${version}";
  version = "1.6";

  src = fetchurl {
    url    = "https://github.com/browndeer/coprthr/archive/stable-${version}.zip";
    sha256 = "0ilx4v1ydppjnq1i0z5j0x4lmi29z39sappar7c0wqady0b5dpz9";
  };

  buildInputs =
    [ libelf libconfig libevent which unzip perl python bison flex ];

  patchPhase = ''
    for x in src/libocl/gen_oclcall_hook.pl tools/cltrace/gen_interceptor.pl src/libocl/gen_oclcall.pl src/scripts/gen_ocl_call_vector.pl src/libstdcl/gen_clarg_setn.pl; do
      substituteInPlace $x --replace "/usr/bin/perl" ${perl}/bin/perl
    done
  '';

  configureFlags =
    [ "--with-libelf=${libelf}"
      "--with-libevent=${libevent.dev}"
      "--with-libconfig=${libconfig}"
      "--with-opencl-icd-path=$out/etc/OpenCL/vendors"
      "--enable-user-install"
    ];

  meta = {
    description = "The CO-PRocessing THReads SDK for OpenCL/STDCL";
    homepage    = "http://www.browndeertechnology.com/coprthr.htm";
    license     = stdenv.lib.licenses.lgpl3;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
    broken = true;
  };
}
