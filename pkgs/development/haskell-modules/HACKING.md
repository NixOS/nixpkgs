
# Maintainer Workflow

The goal of the [@NixOS/haskell](https://github.com/orgs/NixOS/teams/haskell)
team is to keep the Haskell packages in Nixpkgs up-to-date, while making sure
there are no Haskell-related evaluation errors or build errors that get into
the Nixpkgs `master` branch.

We do this by periodically merging an updated set of Haskell packages on the
`haskell-updates` branch into the `master` branch.  Each member of the team
takes a two week period where they are in charge of merging the
`haskell-updates` branch into `master`.  This is the documentation for this
workflow.

The workflow generally proceeds in three main steps:

1. create the initial `haskell-updates` PR, and update Stackage and Hackage snapshots
1. wait for contributors to fix newly broken Haskell packages
1. merge `haskell-updates` into `master`

Each of these steps is described in a separate section.

There is a script that automates the workflow for merging the currently open
`haskell-updates` PR into `master` and opening the next PR.  It is described
at the end of this document.

## Initial `haskell-updates` PR

In this section we create the PR for merging `haskell-updates` into `master`.

1.  Make sure the `haskell-updates` branch is up-to-date with `master`.

1.  Update the Stackage Nightly resolver used by Nixpkgs and create a commit:

    ```console
    $ ./maintainers/scripts/haskell/update-stackage.sh --do-commit
    ```

1.  Update the Hackage package set used by Nixpkgs and create a commit:

    ```console
    $ ./maintainers/scripts/haskell/update-hackage.sh --do-commit
    ```

1.  Regenerate the Haskell package set used in Nixpkgs and create a commit:

    ```console
    $ ./maintainers/scripts/haskell/regenerate-hackage-packages.sh --do-commit
    ```

1.  Push these commits to the `haskell-updates` branch of the NixOS/nixpkgs repository.

1.  Open a PR on Nixpkgs for merging `haskell-updates` into `master`.  The recommended
    PR title and body text are described in the `merge-and-open-pr.sh` section.

## Notify Maintainers and Fix Broken Packages

After you've done the previous steps, Hydra will start building the new and
updated Haskell packages.  You can see the progress Hydra is making at
https://hydra.nixos.org/jobset/nixpkgs/haskell-updates.  This Hydra jobset is
defined in the file [release-haskell.nix](../../top-level/release-haskell.nix).

### Notify Maintainers

When Hydra finishes building all the updated packages for the `haskell-updates`
jobset, you should generate a build report to notify maintainers of their
newly broken packages.  You can do that with the following commands:

```console
$ ./maintainers/scripts/haskell/hydra-report.hs get-report
$ ./maintainers/scripts/haskell/hydra-report.hs ping-maintainers
```

The `hydra-report.hs ping-maintainers` command generates a Markdown document
that you can paste in a GitHub comment on the PR opened above.  This
comment describes which Haskell packages are now failing to build.  It also
pings the maintainers so that they know to fix up their packages.

It may be helpful to pipe `hydra-report.hs ping-maintainers` into `xclip`
(XOrg) or `wl-copy` (Wayland) in order to post on GitHub.

This build report can be fetched and re-generated for new Hydra evaluations.
It may help contributors to try to keep the GitHub comment updated with the
most recent build report.

Maintainers should be given at least 7 days to fix up their packages when they
break.  If maintainers don't fix up their packages within 7 days, then they
may be marked broken before merging `haskell-updates` into `master`.

### Fix Broken Packages

After getting the build report, you can see which packages and Hydra jobs are
failing to build.  The most important jobs are the
[`maintained`](https://hydra.nixos.org/job/nixpkgs/haskell-updates/maintained) and
[`mergeable`](https://hydra.nixos.org/job/nixpkgs/haskell-updates/mergeable)
jobs. These are both defined in
[`release-haskell.nix`](../../top-level/release-haskell.nix).

`mergeable` is a set of the most important Haskell packages, including things
like Pandoc and XMonad.  These packages are widely used.  We would like to
always keep these building.

`maintained` is a set of Haskell packages that have maintainers in Nixpkgs.
We should be proactive in working with maintainers to keep their packages
building.

Steps to fix Haskell packages that are failing to build is out of scope for
this document, but it usually requires fixing up dependencies that are now
out-of-bounds.

### Mark Broken Packages

Packages that do not get fixed can be marked broken with the following
commands.  First check which packages are broken:

```console
$ ./maintainers/scripts/haskell/hydra-report.hs get-report
$ ./maintainers/scripts/haskell/hydra-report.hs mark-broken-list
```

This shows a list of packages that reported a build failure on `x86_64-linux` on Hydra.

Next, run the following command:

```console
$ ./maintainers/scripts/haskell/mark-broken.sh --do-commit
```

This first opens up an editor with the broken package list.  Some of these
packages may have a maintainer in Nixpkgs.  If these maintainers have not been
given 7 days to fix up their package, then make sure to remove those packages
from the list before continuing.  After saving and exiting the editor, the
following will happen:

-   Packages from the list will be added to
    [`configuration-hackage2nix/broken.yaml`](configuration-hackage2nix/broken.yaml).
    This is a list of Haskell packages that are known to be broken.

-   [`hackage-packages.nix`](hackage-packages.nix) will be regenerated.  This
    will mark all Haskell pacakges in `configuration-hackage2nix/broken.yaml`
    as `broken`.

-   The
    [`configuration-hackage2nix/transitive-broken.yaml`](configuration-hackage2nix/transitive-broken.yaml)
    file will be updated.  This is a list of Haskell packages that
    depend on a package in `configuration-hackage2nix/broken.yaml` or
    `configuration-hackage2nix/transitive-broken.yaml`

-   `hackage-packages.nix` will be regenerated again.  This will set
    `hydraPlatforms = none` for all the packages in
    `configuration-hackage2nix/transitive-broken.yaml`.  This makes
    sure that Hydra does not try to build any of these packages.

-   All updated files will be committed.

## Merge `haskell-updates` into `master`

Now it is time to merge the `haskell-updates` PR you opened above.

Before doing this, make sure of the following:

-   All Haskell packages that fail to build are correctly marked broken or
    transitively broken.

-   The `maintained` and `mergeable` jobs are passing on Hydra.

-   The maintainers for any maintained Haskell packages that are newly broken
    have been pinged on GitHub and given at least a week to fix their packages.
    This is especially important for widely-used packages like `cachix`.

-   Make sure you first merge the `master` branch into `haskell-updates`.  Wait
    for Hydra to evaluate the new `haskell-updates` jobset.  Make sure you only
    merge `haskell-updates` into `master` when there are no evaluation errors.

-   Due to Hydra having only a small number of Darwin build machines, the
    `haskell-updates` jobset on Hydra often has many queued Darwin jobs.
    In order to not have these queued Darwin jobs prevent the `haskell-updates`
    branch from being merged to `master` in a timely manner, we have special
    rules for Darwin jobs.

    -   It is alright to merge the `haskell-updates` branch to `master` if
        there are remaining queued Darwin jobs on Hydra.

    -   We would like to keep GHC and the `mergeable` job building on Darwin.
        Do not merge the `haskell-updates` branch to `master` if GHC is failing
        to build, or the `mergeable` job has failing Darwin constituent jobs.

        If GHC and the `mergeable` job are not failing, but merely queued,
        it is alright to merge the `haskell-updates` branch to `master`.

    -   We do not need to keep the `maintained` job building on Darwin.
        If `maintained` packages are failing on Darwin, it is helpful to
        mark them as broken on that platform.

When you've double-checked these points, go ahead and merge the `haskell-updates` PR.
After merging, **make sure not to delete the `haskell-updates` branch**, since it
causes all currently open Haskell-related pull-requests to be automatically closed on GitHub.

## Script for Merging `haskell-updates` and Opening a New PR

There is a script that automates merging the current `haskell-updates` PR and
opening the next one.  When you want to merge the currently open
`haskell-updates` PR, you can run the script with the following steps:

1.  Make sure you have previously authenticated with the `gh` command.  The
    script uses the `gh` command to merge the current PR and open a new one.
    You should only need to do this once.

    This command can be used to authenticate:

    ```console
    $ gh auth login
    ```

    This command can be used to confirm that you have already authenticated:

    ```console
    $ gh auth status
    ```

1.  Make sure you have setup your `~/.cabal/config` file for authentication
    for uploading the NixOS package versions to Hackage.  See the following
    section for details on how to do this.

1.  Make sure you have correctly marked packages broken.  One of the previous
    sections explains how to do this.

    In short:

    ```console
    $ ./maintainers/scripts/haskell/hydra-report.hs get-report
    $ ./maintainers/scripts/haskell/hydra-report.hs mark-broken-list
    $ ./maintainers/scripts/haskell/mark-broken.sh --do-commit
    ```

1.  Merge `master` into `haskell-updates` and make sure to push to the
    `haskell-updates` branch.  (This can be skipped if `master` has recently
    been merged into `haskell-updates`.)

1.  Go to https://hydra.nixos.org/jobset/nixpkgs/haskell-updates and force an
    evaluation of the `haskell-updates` jobset.  See one of the following
    sections for how to do this.  Make sure there are no evaluation errors.  If
    there are remaining evaluation errors, fix them before continuing with this
    merge.

1.  Run the script to merge `haskell-updates`:

    ```console
    $ ./maintainers/scripts/haskell/merge-and-open-pr.sh PR_NUM_OF_CURRENT_HASKELL_UPDATES_PR
    ```

    Find the PR number easily [here](https://github.com/nixos/nixpkgs/pulls?q=is%3Apr+is%3Aopen+head%3Ahaskell-updates)

    This does the following things:

    1.  Fetches `origin`, makes sure you currently have the `haskell-updates`
        branch checked out, and makes sure your currently checked-out
        `haskell-updates` branch is on the same commit as
        `origin/haskell-updates`.

    1.  Merges the currently open `haskell-updates` PR.

    1.  Updates the version of Haskell packages in NixOS on Hackage.

    1.  Updates Stackage and Hackage snapshots.  Regenerates the Haskell package set.

    1.  Pushes the commits updating Stackage and Hackage and opens a new
        `haskell-updates` PR on Nixpkgs.  If you'd like to do this by hand,
        look in the script for the recommended PR title and body text.

## Update Hackage Version Information

After merging into `master` you can update what Hackage displays as the current
version in NixOS for every individual package.  To do this you run
`maintainers/scripts/haskell/upload-nixos-package-list-to-hackage.sh`.  See the
script for how to provide credentials. Once you have configured credentials,
running this takes only a few seconds.

## Additional Info

Here are some additional tips that didn't fit in above.

-   Hydra tries to evaluate the `haskell-updates` branch (in the
    [`nixpkgs:haskell-updates`](https://hydra.nixos.org/jobset/nixpkgs/haskell-updates)
    jobset) every 4 hours.  It is possible to force a new Hydra evaluation without
    waiting 4 hours by the following steps:

    1. Log into Hydra with your GitHub or Google account.
    1. Go to the [nixpkgs:haskell-updates](https://hydra.nixos.org/jobset/nixpkgs/haskell-updates) jobset.
    1. Click the `Actions` button.
    1. Select `Evaluate this jobset`.
    1. If you refresh the page, there should be a new `Evaluation running since:` line.
    1. Evaluations take about 10 minutes to finish.

-   It is sometimes helpful to update the version of
    [`cabal2nix` / `hackage2nix`](https://github.com/NixOS/cabal2nix) that our
    maintainer scripts use.  This can be done with the
    [`maintainers/scripts/haskell/update-cabal2nix-unstable.sh`](../../../maintainers/scripts/haskell/update-cabal2nix-unstable.sh)
    script.

    You might want to do this if a user contributes a fix to `cabal2nix` that
    will immediately fix a Haskell package in Nixpkgs.  First, merge in
    the PR to `cabal2nix`, then run `update-cabal2nix-upstable.sh`.  Finally, run
    [`regenerate-hackage-packages.sh`](../../../maintainers/scripts/haskell/regenerate-hackage-packages.sh)
    to regenerate the Hackage package set with the updated version of `hackage2nix`.

-   Make sure never to update the Hackage package hashes in
    [`pkgs/data/misc/hackage/`](../../../pkgs/data/misc/hackage/), or the
    pinned Stackage Nightly versions on the release branches (like
    `release-21.05`).

    This means that the
    [`update-hackage.sh`](../../../maintainers/scripts/haskell/update-hackage.sh)
    and
    [`update-stackage.sh`](../../../maintainers/scripts/haskell/update-stackage.sh)
    scripts should never be used on the release branches.

    However, changing other files in `./.` and regenerating the package set is encouraged.
    This can be done with
    [`regenerate-hackage-packages.sh`](../../../maintainers/scripts/haskell/regenerate-hackage-packages.sh)
    as described above.

-   The Haskell team members generally hang out in the Matrix room
    [#haskell:nixos.org](https://matrix.to/#/#haskell:nixos.org).

-   This is a checklist for things that need to happen when a new
    member is added to the Nixpkgs Haskell team.

    1.  Add the person to the
        [@NixOS/haskell](https://github.com/orgs/NixOS/teams/haskell)
        team.  You may need to ask someone in the NixOS organization
        to do this, like [@domenkozar](https://github.com/domenkozar).
        This gives the new member access to the GitHub repos like
        [cabal2nix](https://github.com/NixOS/cabal2nix).

    1.  Add the person as a maintainer for the following packages
        on Hackage:
        - https://hackage.haskell.org/package/cabal2nix
        - https://hackage.haskell.org/package/distribution-nixpkgs
        - https://hackage.haskell.org/package/hackage-db
        - https://hackage.haskell.org/package/jailbreak-cabal
        - https://hackage.haskell.org/package/language-nix

    1.  Add the person to the `haskell` team in
        [`maintainers/team-list.nix`](../../../maintainers/team-list.nix).
        This team is responsible for some important packages in
        [release-haskell.nix](../../top-level/release-haskell.nix).

    1.  Update the
        [Nextcloud Calendar](https://cloud.maralorn.de/apps/calendar/p/H6migHmKX7xHoTFa)
        and work the new member into the `haskell-updates` rotation.

    1.  Optionally, have the new member add themselves to the Haskell
        section in [`CODEOWNERS`](../../../.github/CODEOWNERS).  This
        will cause them to get pinged on most Haskell-related PRs.
