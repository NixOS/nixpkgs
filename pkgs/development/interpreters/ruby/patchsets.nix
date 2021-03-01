{ patchSet, useRailsExpress, ops, patchLevel, fetchpatch }:

{
  "2.5.8" = ops useRailsExpress [
    "${patchSet}/patches/ruby/2.5/head/railsexpress/01-fix-broken-tests-caused-by-ad.patch"
    "${patchSet}/patches/ruby/2.5/head/railsexpress/02-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.5/head/railsexpress/03-more-detailed-stacktrace.patch"
  ];
  "2.6.6" = ops useRailsExpress [
    "${patchSet}/patches/ruby/2.6/head/railsexpress/01-fix-broken-tests-caused-by-ad.patch"
    "${patchSet}/patches/ruby/2.6/head/railsexpress/02-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.6/head/railsexpress/03-more-detailed-stacktrace.patch"
  ];
  "2.7.2" = ops useRailsExpress [
    "${patchSet}/patches/ruby/2.7/head/railsexpress/01-fix-broken-tests-caused-by-ad.patch"
    "${patchSet}/patches/ruby/2.7/head/railsexpress/02-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.7/head/railsexpress/03-more-detailed-stacktrace.patch"
  ];
}
