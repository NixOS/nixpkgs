{ mkDerivation, lib, fetchFromGitHub
, cmake, cmake-extras, intltool
, qtbase, qtxmlpatterns, libapparmor, gsettings-qt, click, qdjango, libqtdbustest
# click-ubuntu dependencies
, json-glib
}:

mkDerivation rec {
  pname = "libusermetrics-unstable";
  version = "2019-01-01";

  src = fetchFromGitHub {
    owner = "ubports";
    repo = "libusermetrics";
    rev = "ed7dd5d3fb5b01c345f942561008c4ca86568b34";
    sha256 = "051wal8bhd0ww0zspiid5j5z4nfdjyrl8xj673qy59iax3s15xbs";
  };

  postPatch = ''
    substituteInPlace data/CMakeLists.txt \
      --replace "/etc" "$out/etc"
  '';

  nativeBuildInputs = [ cmake cmake-extras intltool ];

  buildInputs = [ qtbase qtxmlpatterns libapparmor gsettings-qt click qdjango libqtdbustest json-glib ];

  # TODO can't find click pkg-config dependencies?
  NIX_CFLAGS_COMPILE = [
    "-isystem ${json-glib.dev}/include/json-glib-1.0"
  ];

  cmakeFlags = [ "-DGSETTINGS_LOCALINSTALL=ON" ];

  meta = with lib; {
    description = "Library for exporting anonymous metrics about users";
    longDescription = ''
      Libusermetrics enables apps to locally store interesting numerical data for
      later presentation. For example in the Ubuntu Greeter "flower" infographic.

      * All data is stored locally in /var/usermetrics/.
      * No data is centrally collected via a web-service or otherwise, and no data is
        sent over the internet.

      The only data that can be stored is numerical, for example "number of e-mails"
      or "number of pictures taken". No personally identifying information is stored
      using this library.
    '';
    homepage = "https://launchpad.net/libusermetrics";
    license = with licenses; [ lgpl3Only lgpl21Only gpl3Only ];
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
}
