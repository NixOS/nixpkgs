{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "a52dec";
  version = "0.7.4";

  src = fetchurl {
    url = "https://liba52.sourceforge.io/files/${pname}-${version}.tar.gz";
    sha256 = "oh1ySrOzkzMwGUNTaH34LEdbXfuZdRPu9MJd5shl7DM=";
  };

  configureFlags = [
    "--enable-shared"

    # Workaround a52dec's configure bug: when 'inline' keyword is supported
    # (ac_cv_c_inline=inline detection) it gets substituted to __attribute__((alwaus_inline))
    # and effectively removes 'inline' keyword. That causes build failures on darwin
    # when function is present in multiple translation units:
    #   https://hydra.nixos.org/build/181576456
    # By setting 'ac_cv_c_inline=yes' we both keep 'inline' keyword and
    # don't substitute it for _attribute__(()) annotation.

    # Check it fails first:
    # "ac_cv_c_inline=yes"
  ];

  makeFlags = [
    "AR=${stdenv.cc.targetPrefix}ar"
  ];

  # fails 1 out of 1 tests with "BAD GLOBAL SYMBOLS" on i686
  # which can also be fixed with
  # hardeningDisable = lib.optional stdenv.isi686 "pic";
  # but it's better to disable tests than loose ASLR on i686
  doCheck = !stdenv.isi686;

  meta = with lib; {
    description = "ATSC A/52 stream decoder";
    homepage = "https://liba52.sourceforge.io/";
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
  };
}
