{ stdenv, fetchFromGitHub, perl, cmake }:

stdenv.mkDerivation rec {
  name = "libical-${version}";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "libical";
    repo = "libical";
    rev = "v${version}";
    sha256 = "0xsvqy1hzmwxn783wrb2k8p751544pzv39v9ynr9pj4yzkwjzsvb";
  };

  nativeBuildInputs = [ perl cmake ];

  patches = [
    # TODO: upstream this patch
    ./respect-env-tzdir.patch
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/libical/libical;
    description = "An Open Source implementation of the iCalendar protocols";
    license = licenses.mpl10;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
