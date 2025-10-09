{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # dependencies
  cmake,
  python-dateutil,
  dbus-python,
  dnf4,
  gettext,
  libcomps,
  libdnf,
  python,
  rpm,
  sphinx,
  systemd,
}:

let
  pyMajor = lib.versions.major python.version;
in

buildPythonPackage rec {
  pname = "dnf-plugins-core";
  version = "4.10.1";
  format = "other";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = "dnf-plugins-core";
    tag = version;
    hash = "sha256-nZyM61bQ9L4t3/fa9cP+xo9ke00e6w2Obt80OpqOG8A=";
  };

  patches = [
    # Fix building with CMake 4
    (fetchpatch {
      url = "https://github.com/rpm-software-management/dnf-plugins-core/commit/1f5d725d857b61760174dd09165e885dd63762c5.patch?full_index=1";
      hash = "sha256-dI6tVokgenb4aaLH5YuG3EZ1Ehgf/NwwPprcDWcHt2Q=";
    })
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "SYSCONFDIR /etc" "SYSCONFDIR $out/etc" \
      --replace-fail "SYSTEMD_DIR /usr/lib/systemd/system" "SYSTEMD_DIR $out/lib/systemd/system"
    substituteInPlace doc/CMakeLists.txt \
      --replace-fail 'SPHINX_BUILD_NAME "sphinx-build-3"' 'SPHINX_BUILD_NAME "${sphinx}/bin/sphinx-build"'
  '';

  nativeBuildInputs = [
    cmake
    gettext
    sphinx
  ];

  propagatedBuildInputs = [
    python-dateutil
    dbus-python
    dnf4.py
    libcomps
    libdnf
    rpm
    systemd
  ];

  cmakeFlags = [
    "-DPYTHON_DESIRED=${pyMajor}"
    "-DWITHOUT_LOCAL=0"
    "-DPYTHON_INSTALL_DIR=${placeholder "out"}/${python.sitePackages}"
  ];

  postBuild = ''
    make doc-man
  '';

  pythonImportsCheck = [
    # This is the python module imported by dnf4 when plugins are loaded.
    "dnfpluginscore"
  ];

  # Don't use symbolic links so argv[0] is set to the correct value.
  postInstall = ''
    # See https://github.com/rpm-software-management/dnf-plugins-core/blob/aee9cacdeb50768c1e869122cd432924ec533213/dnf-plugins-core.spec#L478
    mv $out/libexec/dnf-utils-${pyMajor} $out/libexec/dnf-utils

    # See https://github.com/rpm-software-management/dnf-plugins-core/blob/aee9cacdeb50768c1e869122cd432924ec533213/dnf-plugins-core.spec#L487-L503
    bins=(
      "debuginfo-install"
      "needs-restarting"
      "find-repos-of-install"
      "repo-graph"
      "package-cleanup"
      "repoclosure"
      "repodiff"
      "repomanage"
      "repoquery"
      "reposync"
      "repotrack"
      "yum-builddep"
      "yum-config-manager"
      "yum-debug-dump"
      "yum-debug-restore"
      "yum-groups-manager"
      "yumdownloader"
    )
    mkdir -p $out/bin
    for bin in "''${bins[@]}"; do
      ln $out/libexec/dnf-utils $out/bin/$bin
    done
  '';

  makeWrapperArgs = [ ''--add-flags "--setopt=pluginpath=$out/${python.sitePackages}/dnf-plugins"'' ];

  meta = with lib; {
    description = "Core plugins to use with DNF package manager";
    homepage = "https://github.com/rpm-software-management/dnf-plugins-core";
    changelog = "https://github.com/rpm-software-management/dnf-plugins-core/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ katexochen ];
  };
}
