
## Maintainer Workflow

This is the documentation for periodically merging the `haskell-updates` branch
into the `master` branch.  This workflow is performed by members in the
[@NixOS/haskell](https://github.com/orgs/NixOS/teams/haskell) team.
Each member of the team takes a two week period where they much merge the
`haskell-updates` branch into `master`.

The goal of this workflow is to regularly merge the `haskell-updates` branch
into the `master` branch, while making sure there are no evaluation errors or
build errors that get into `master`.

The workflow generally proceeds in three main steps:

1. create the initial `haskell-updates` PR
1. wait for contributors to fix newly broken Haskell packages
1. merge `haskell-updates` into `master`

We describe each of these steps in a separate section.

### Initial `haskell-updates` PR

In this section we create the PR for merging `haskell-updates` into `master`.

1.  Make sure the `haskell-updates` branch is up-to-date with `master`.

1.  Update the Stackage Nightly resolver used by Nixpkgs and create a commit:

    ```console
    $ maintainers/scripts/haskell/update-stackage.sh --do-commit
    ```

1.  Update the Hackage package set used by Nixpkgs and create a commit:

    ```console
    $ maintainers/scripts/haskell/update-hackage.sh --do-commit
    ```

1.  Regenerate the Haskell package set used in Nixpkgs and create a commit:

    ```console
    $ maintainers/scripts/haskell/regenerate-hackage-packages.sh --do-commit
    ```

1.  Push these commits to the Nixpkgs repo.

1.  Open a PR on Nixpkgs merging `haskell-updates` into `master`.

Use the following message body:

```markdown
### This Merge

This PR is the regularly merge of the `haskell-updates` branch into `master`.

This branch is being continually built and tested by hydra at https://hydra.nixos.org/jobset/nixpkgs/haskell-updates.

I will aim to merge this PR **by 2021-TODO-TODO**. If I can merge it earlier, there might be successor PRs in that time window. As part of our rotation @TODO will continue these merges from 2021-TODO-TODO to 2021-TODO-TODO.

### haskellPackages Workflow Summary

Our workflow is currently described at `pkgs/development/haskell-modules/HACKING.md`.

The short version is this:
* We regularly update the stackage and hackage pins on `haskell-updates` (normally at the beginning of a merge window).
* The community fixes builds of Haskell packages on that branch.
* We aim at at least one merge of `haskell-updates` into `master` every two weeks.
* We only do the merge if the `mergeable` job is succeeding on hydra.
* If a maintained package is still broken at the time of merge, we will only merge if the maintainer has been pinged 7 days in advance. (If you care about a Haskell package, become a maintainer!)

---

This is the follow-up to #TODO.
```

Make sure to replace all TODO with the actual values.

### Notify Maintainers and Fix Broken Packages

After you've done the previous steps, Hydra will start building the new and
updated Haskell packages.  You can see the progress Hydra is making at
https://hydra.nixos.org/jobset/nixpkgs/haskell-updates.  This Hydra jobset is
defined in the file [release-haskell.nix](../../top-level/release-haskell.nix).

#### Notify Maintainers

When Hydra finishes building all the packages, you should generate a build
report to notify maintainers of their broken packages.  You can do that with the
following commands:

```console
$ maintainers/scripts/haskell/hydra-report.hs get-report
$ maintainers/scripts/haskell/hydra-report.hs ping-maintainers
```

The `hyda-report.hs ping-maintainers` command generates a Markdown document
that you can paste in a GitHub comment on the PR opened above.  This
comment describes which Haskell packages are now failing to build.  It also
pings the maintainers so that they know to fix up their packages.

This build report can be fetched and re-generated for new Hydra evaluations.
It may help contributors to try to keep the GitHub comment updated with the
most recent build report.

#### Fix Broken Packages

After getting the build report, you can see which packages and Hydra jobs are
failing to build.  The most important jobs are the `maintained` and `mergeable`
jobs. These are both defined in
[`release-haskell.nix](../../top-level/release-haskell.nix).

`mergeable` is a set of the most important Haskell packages, including things
like Pandoc and XMonad.  These packages are widely used.  We would like to
always keep these building.

`maintained` is a set of Haskell packages that have maintainers in Nixpkgs.
We should be proactive in working with maintainers to keep their packages
building.

Steps to fix Haskell packages that are failing to build is out of scope for
this document, but it usually requires fixing up dependencies that now
out-of-bounds.

### Merge `haskell-updates` into `master`

(TODO)

- mark broken packages with `mark-broken.sh`

### Additional Info

(TODO)

- you can restart a Hydra evaluation by logging in with github.

## Contributor Workflow

(TODO: this section is to describe the type of workflow for non-comitters to
contribute to `haskell-updates`)
