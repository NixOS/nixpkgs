## How to upgrade llvm_git

- Run `update-git.py`.
  This will set the github revision and sha256 for `llvmPackages_git.llvm` to whatever the latest chromium build is using.
  For a more recent, commit run `nix-prefetch-github` and change the rev and sha256 accordingly.

- That was the easy part.
  The hard part is updating the patch files.

  The general process is:

  1. Try to build `llvmPackages_git.llvm` and associated packages such as
     `clang` and `compiler-rt`. You can use the `-L` and `--keep-failed` flags to make
     debugging patch errors easy, e.g., `nix build .#llvmPackages_git.clang -L --keep-failed`

  2. The build will error out with something similar to this:
     ```sh
     ...
     clang-unstable> patching sources
     clang-unstable> applying patch /nix/store/nndv6gq6w608n197fndvv5my4a5zg2qi-purity.patch
     clang-unstable> patching file lib/Driver/ToolChains/Gnu.cpp
     clang-unstable> Hunk #1 FAILED at 487.
     clang-unstable> 1 out of 1 hunk FAILED -- saving rejects to file lib/Driver/ToolChains/Gnu.cpp.rej
     note: keeping build directory '/tmp/nix-build-clang-unstable-2022-25-07.drv-17'
     error: builder for '/nix/store/zwi123kpkyz52fy7p6v23azixd807r8c-clang-unstable-2022-25-07.drv' failed with exit code 1;
            last 8 log lines:
            > unpacking sources
            > unpacking source archive /nix/store/mrxadx11wv1ckjr2208qgxp472pmmg6g-clang-src-unstable-2022-25-07
            > source root is clang-src-unstable-2022-25-07/clang
            > patching sources
            > applying patch /nix/store/nndv6gq6w608n197fndvv5my4a5zg2qi-purity.patch
            > patching file lib/Driver/ToolChains/Gnu.cpp
            > Hunk #1 FAILED at 487.
            > 1 out of 1 hunk FAILED -- saving rejects to file lib/Driver/ToolChains/Gnu.cpp.rej
            For full logs, run 'nix log /nix/store/zwi123kpkyz52fy7p6v23azixd807r8c-clang-unstable-2022-25-07.drv'.
     note: keeping build directory '/tmp/nix-build-compiler-rt-libc-unstable-2022-25-07.drv-20'
     error: 1 dependencies of derivation '/nix/store/ndbbh3wrl0l39b22azf46f1n7zlqwmag-clang-wrapper-unstable-2022-25-07.drv' failed to build
     ```

     Notice the `Hunk #1 Failed at 487` line.
     The lines above show us that the `purity.patch` failed on `lib/Driver/ToolChains/Gnu.cpp` when compiling `clang`.

 3. The task now is to cross reference the hunks in the purity patch with
    `lib/Driver/ToolCahins/Gnu.cpp.orig` to see why the patch failed.
    The `.orig` file will be in the build directory referenced in the line `note: keeping build directory ...`;
    this message results from the `--keep-failed` flag.

 4. Now you should be able to open whichever patch failed, and the `foo.orig` file that it failed on.
    Correct the patch by adapting it to the new code and be mindful of whitespace;
    which can be an easily missed reason for failures.
    For cases where the hunk is no longer needed you can simply remove it from the patch.

 This is fine for small corrections, but when more serious changes are needed its better to use git.

 1. Clone the LLVM monorepo at https://github.com/llvm/llvm-project/

 2. Check out the revision we were using before.

 3. Use `patch -p1 < path/to-path` in the project subdirectories to apply the patches and commit.

 4. Use `git rebase HEAD^ --onto <dest>` to rebase the patches onto the new revision we are trying to build, and fix all conflicts.

 5. Use `git diff HEAD^:<project> HEAD:<project>` to get subdir diff to write back to Nixpkgs.

## Information on our current patch sets

### "GNU Install Dirs" patches

Use CMake's [`GNUInstallDirs`](https://cmake.org/cmake/help/latest/module/GNUInstallDirs.html) to support multiple outputs.

Previously, LLVM Just hard-coded `bin`, `include`, and `lib${LLVM_TARGET_PREFIX}`.
We are making it use these variables.

For the older LLVM versions, these patches live in https://github.com/Ericson2314/llvm-project branches `split-prefix`.
Instead of applying the patches to the worktree per the above instructions, one can checkout those directly and rebase those instead.

For newer LLVM versions, enough has has been upstreamed,
(see https://reviews.llvm.org/differential/query/5UAfpj_9zHwY/ for my progress upstreaming),
that I have just assembled new gnu-install-dirs patches from the remaining unmerged patches instead of rebasing from the prior LLVM's gnu install dirs patch.
