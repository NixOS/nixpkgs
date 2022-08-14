{ lib, buildPythonPackage, python, fetchFromGitHub
, fetchpatch
, cmake, sip, protobuf, pythonOlder, symlinkJoin, pkg-config, j2cli }:

buildPythonPackage rec {
  pname = "libarcus";
  version = "5.1.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "libArcus";
    rev = version;
    sha256 = "sha256-aGuNE7K5We/8QT8Gl/vBfFn7CXdpqbmiQZLc2JvO6pk=";
  };

  disabled = pythonOlder "3.4";

  propagatedBuildInputs = [ sip ];
  nativeBuildInputs = [ cmake python pkg-config ];
  buildInputs = [ protobuf python ];

  cmakeFlags = [
    "-DPython_SITELIB_LOCAL=${python.sitePackages}"
  ];

  postPatch = ''
    sed -i '2i find_package(PkgConfig)' CMakeLists.txt
    sed -i 's|find_package(cpython REQUIRED)|pkg_check_modules(python REQUIRED IMPORTED_TARGET python)|' CMakeLists.txt
    sed -i 's|cpython::cpython|PkgConfig::python|g' CMakeLists.txt
    cat CMakeLists.txt

    mkdir -p build/pyArcus/
    module_name=pyArcus sip_dir=$(pwd)/python sip_include_dirs=$(pwd)/python build_dir=$(pwd)/build/pyArcus/ \
      ${j2cli}/bin/j2 pyproject.toml.jinja -o pyproject.toml
    ln -s cmake/CMakeBuilder.py CMakeBuilder.py
    ${sip}/bin/sip-build --pep484-pyi --no-protected-is-public # -y pyArcus.pyi
  '';

  meta = with lib; {
    description = "Communication library between internal components for Ultimaker software";
    homepage = "https://github.com/Ultimaker/libArcus";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar gebner ];
  };
}
