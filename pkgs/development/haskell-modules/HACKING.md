
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

### Fix Broken Packages

(TODO)

### Merge `haskell-updates` into `master`

(TODO)

## Contributor Workflow

(TODO: this section is to describe the type of workflow for non-comitters to
contribute to `haskell-updates`)
