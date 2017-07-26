Node.js packages
===============
To add a package from [NPM](https://www.npmjs.com/) to nixpkgs:

 1. Install node2nix: `nix-env -f '<nixpkgs>' -iA nodePackages.node2nix`.
 2. Modify `pkgs/development/node-packages/node-packages.json`, to add, update,
    or remove package entries.
 3. Run the script: `cd pkgs/development/node-packages && sh generate.sh`.
 4. Build your new package to test your changes: `cd /path/to/nixpkgs &&
   nix-build -A nodePackages.<new-or-updated-package>`. To build against a
   specific node.js version (e.g. 5.x): `nix-build -A
   nodePackages_5_x.<new-or-updated-package>`
 5. Add, commit, and share your changes!
