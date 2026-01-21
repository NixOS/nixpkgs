# See also
# https://pysdl3.readthedocs.io/en/latest/install.html#the-environment-variable-method

# Don't check Pypi for new PySDL3 releases at runtime
export SDL_CHECK_VERSION=0
# Don't try to download SDL binaries at runtime
export SDL_DOWNLOAD_BINARIES=0
# Nixpkgs does not provide a metadata.json. Instead we want PySDL3 to find the
# SDL libraries we symlink into its site-packages
export SDL_DISABLE_METADATA=1
