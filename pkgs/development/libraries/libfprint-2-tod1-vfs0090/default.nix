{ stdenv, lib, fetchFromGitLab, pkg-config, libfprint, libfprint-tod, gusb, udev, nss, openssl, meson, pixman, ninja, glib }:
stdenv.mkDerivation rec{
  pname = "libfprint-2-tod1-vfs0090";
  version = "0.96.91";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "3v1n0";
    repo = "libfprint-tod-vfs0090";
    rev = "${version}";
    sha256 = "sha256-Qy2GYyx5aG1HfeAMVsiI3wLbfaN0bfjAOG0Jd9OnCdU=";
  };

  patches = [
    # TODO remove once https://gitlab.freedesktop.org/3v1n0/libfprint-tod-vfs0090/-/merge_requests/1 is merged
    ./0001-vfs0090-add-missing-explicit-dependencies-in-meson.b.patch
    # TODO remove once https://gitlab.freedesktop.org/3v1n0/libfprint-tod-vfs0090/-/merge_requests/2 is merged
    ./0002-vfs0090-add-missing-linux-limits.h-include.patch
    ./0003-Update-fpi_ssm_next_state_delayed-calls.patch
  ];

  nativeBuildInputs = [ pkg-config meson ninja ];
  buildInputs = [ libfprint libfprint-tod glib gusb udev nss openssl pixman ];

  installPhase = ''
    runHook preInstall

    install -D -t "$out/lib/libfprint-2/tod-1/" libfprint-tod-vfs009x.so
    install -D -t "$out/lib/udev/rules.d/" $src/60-libfprint-2-tod-vfs0090.rules

    runHook postInstall
  '';

  passthru.driverPath = "/lib/libfprint-2/tod-1";

  meta = with lib; {
    description = "Libfprint-2-tod Touch OEM Driver for 2016 ThinkPad's fingerprint readers";
    homepage = "https://gitlab.freedesktop.org/3v1n0/libfprint-tod-vfs0090";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ valodim ];
  };
}
