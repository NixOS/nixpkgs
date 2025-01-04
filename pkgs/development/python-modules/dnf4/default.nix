{
  lib,
  buildPythonPackage,
  cmake,
  fetchFromGitHub,
  gettext,
  libcomps,
  libdnf,
  python,
  rpm,
  sphinx,
  nix-update-script,
}:

let
  pyMajor = lib.versions.major python.version;
in

buildPythonPackage rec {
  pname = "dnf4";
  version = "4.22.0";
  format = "other";

  outputs = [
    "out"
    "man"
    "py"
  ];

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = "dnf";
    rev = version;
    hash = "sha256-I79cwK+xPmHS3z8/rKar5G5EbK6IYq0Ypq9KrShJ3sg=";
  };

  patches = [ ./fix-python-install-dir.patch ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "@PYTHON_INSTALL_DIR@" "$out/${python.sitePackages}" \
      --replace "SYSCONFDIR /etc" "SYSCONFDIR $out/etc" \
      --replace "SYSTEMD_DIR /usr/lib/systemd/system" "SYSTEMD_DIR $out/lib/systemd/system"
    substituteInPlace etc/tmpfiles.d/CMakeLists.txt \
      --replace "DESTINATION /usr/lib/tmpfiles.d" "DESTINATION $out/usr/lib/tmpfiles.d"
    substituteInPlace dnf/const.py.in \
      --replace "/etc" "$out/etc" \
      --replace "/var/tmp" "/tmp"
    substituteInPlace doc/CMakeLists.txt \
      --replace 'SPHINX_BUILD_NAME "sphinx-build-3"' 'SPHINX_BUILD_NAME "${sphinx}/bin/sphinx-build"'
  '';

  nativeBuildInputs = [
    cmake
    gettext
    sphinx
  ];

  propagatedBuildInputs = [
    libcomps
    libdnf
    rpm
  ];

  cmakeFlags = [ "-DPYTHON_DESIRED=${pyMajor}" ];

  dontWrapPythonPrograms = true;

  postBuild = ''
    make doc-man
  '';

  postInstall = ''
    # See https://github.com/rpm-software-management/dnf/blob/41a287e2bd60b4d1100c329a274776ff32ba8740/dnf.spec#L218-L220
    ln -s dnf-${pyMajor} $out/bin/dnf
    ln -s dnf-${pyMajor} $out/bin/dnf4
    mv $out/bin/dnf-automatic-${pyMajor} $out/bin/dnf-automatic

    # See https://github.com/rpm-software-management/dnf/blob/41a287e2bd60b4d1100c329a274776ff32ba8740/dnf.spec#L231-L232
    ln -s $out/etc/dnf/dnf.conf $out/etc/yum.conf
    ln -s dnf-${pyMajor} $out/bin/yum

    mkdir -p $out/share/bash-completion/completions
    mv $out/etc/bash_completion.d/dnf-3 $out/share/bash-completion/completions/dnf4
    ln -s $out/share/bash-completion/completions/dnf4 $out/share/bash-completion/completions/dnf
    rm -r $out/etc/bash_completion.d
  '';

  postFixup = ''
    moveToOutput "lib/${python.libPrefix}" "$py"
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Package manager based on libdnf and libsolv. Replaces YUM";
    homepage = "https://github.com/rpm-software-management/dnf";
    changelog = "https://github.com/rpm-software-management/dnf/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ katexochen ];
    mainProgram = "dnf";
    platforms = platforms.unix;
  };
}
