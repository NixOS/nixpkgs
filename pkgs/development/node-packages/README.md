Node.js packages
================
To add a package from [NPM](https://www.npmjs.com/) to nixpkgs:

 1. Modify `pkgs/development/node-packages/node-packages-v6.json` to add, update
    or remove package entries. (Or `pkgs/development/node-packages/node-packages-v4.json`
    for packagages depending on Node.js 4.x)
 2. Run the script: `cd pkgs/development/node-packages && ./generate.sh`.
 3. Build your new package to test your changes:
    `cd /path/to/nixpkgs && nix-build -A nodePackages.<new-or-updated-package>`.
    To build against a specific Node.js version (e.g. 4.x):
    `nix-build -A nodePackages_4_x.<new-or-updated-package>`
 4. Add and commit all modified and generated files.
