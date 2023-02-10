{ patchSet, useRailsExpress, ops, patchLevel, fetchpatch }:

{
  "2.7.7" = ops useRailsExpress [
    "${patchSet}/patches/ruby/2.7/head/railsexpress/01-fix-broken-tests-caused-by-ad.patch"
    "${patchSet}/patches/ruby/2.7/head/railsexpress/02-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.7/head/railsexpress/03-more-detailed-stacktrace.patch"
    "${patchSet}/patches/ruby/2.7/head/railsexpress/04-malloc-trim.patch"
  ];
  "3.0.5" = ops useRailsExpress [
    "${patchSet}/patches/ruby/3.0/head/railsexpress/01-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/3.0/head/railsexpress/02-malloc-trim.patch"
  ];
  "3.1.3" = ops useRailsExpress [
    "${patchSet}/patches/ruby/3.1/head/railsexpress/01-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/3.1/head/railsexpress/02-malloc-trim.patch"
  ];
}
